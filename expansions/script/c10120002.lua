--天选圣女 圣盔葛琳洁德
if not pcall(function() require("expansions/script/c10120001") end) then require("script/c10120001") end
local m=10120002
local cm=_G["c"..m]
function cm.initial_effect(c)
	dsrsv.DanceSpiritSpecialSummonRule(c,cm.sprcon,nil) 
	dsrsv.DanceSpiritSummonSucessEffect(c,m,CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND,cm.sstg,cm.ssop)
	dsrsv.DanceSpiritNegateEffect(c,m,CATEGORY_TOHAND,cm.ntg,cm.nop)
end
function cm.ntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,0,0)
end
function cm.nop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	if tc then
		Duel.GetControl(tc,tp,PHASE_END,1)
	end
end
function cm.ntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_ONFIELD)
end
function cm.nop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function cm.cfilter(c)
	return c:IsFacedown() or not c:IsRace(RACE_FAIRY)
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 and not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.stfilter(c,e,tp)
	return c:IsSetCard(0x9331) and not c:IsCode(m) and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function cm.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.stfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_GRAVE)
end
function cm.ssop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.stfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local sc=g:GetFirst()
		if sc then
			if sc:IsCanBeSpecialSummoned(e,0,tp,false,false)
				and (not sc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(m,3))) then
				Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			else
				Duel.SendtoHand(sc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sc)
			end
		end
	end
end
