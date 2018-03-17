--天选圣女 圣御荷姆薇洁
if not pcall(function() require("expansions/script/c10120001") end) then require("script/c10120001") end
local m=10120004
local cm=_G["c"..m]
function cm.initial_effect(c)
	dsrsv.DanceSpiritSpecialSummonRule(c,cm.sprcon,cm.sprop) 
	dsrsv.DanceSpiritSummonSucessEffect(c,m,CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON,cm.sstg,cm.ssop)  
	dsrsv.DanceSpiritNegateEffect(c,m,CATEGORY_DAMAGE+CATEGORY_TOHAND,cm.ntg,cm.nop)
end
function cm.ntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,1000)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,0,e:GetHandler():GetLocation())
end
function cm.nop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local c=e:GetHandler()
	if Duel.Damage(p,d,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and c:IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
	   Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function cm.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,0,LOCATION_HAND)
end
function cm.ssop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		if tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0x9331) then
			if tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
				and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
		Duel.ShuffleHand(tp)
	end
end
function cm.cfilter(c)
	return c:IsRace(RACE_FAIRY) and not c:IsPublic()
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND,0,2,e:GetHandler())
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND,0,2,2,e:GetHandler())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
