--性感手枪回马枪
if not pcall(function() require("expansions/script/c18004001") end) then require("script/c18004001") end
local m=18004011
local cm=_G["c"..m]
cm.rssetcode="SexGun"
function cm.initial_effect(c)
	rssg.SexGunCode(c)   
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkCode,18004005),2,2,cm.lcheck)
	local e1=rsef.STO(c,EVENT_SPSUMMON_SUCCESS,{m,0},{1,m},"dr,sp","de",rscon.sumtype("link"),cm.cost,cm.tg,cm.op)
	local e2=rsef.QO(c,nil,{m,1},1,"sp",nil,LOCATION_MZONE,cm.spcon,rscost.releaseself(nil,true),cm.sptg,cm.spop)
end
function cm.spcon(e,tp)
	return Duel.GetTurnPlayer()~=tp
end
function cm.lcheck(g,lc)
	return g:IsExists(Card.IsType,1,nil,TYPE_TUNER)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND) 
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		if tc:IsType(TYPE_MONSTER) and tc:IsCode(18004005) and  tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then 
			rssf.SpecialSummon(tc)
		end
		Duel.ShuffleHand(tp)
	end
end
function cm.spfilter(c,e,tp)
	return rssg.IsSexGun(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and rssg.IsSexGun(c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,e:GetHandler())>0
		and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCountFromEx(tp)
	if ft<=0 or not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc and rssf.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO)~=0 then
		tc:CompleteProcedure()
	end
end
