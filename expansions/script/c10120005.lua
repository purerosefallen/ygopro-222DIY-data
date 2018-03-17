--天选圣女 圣剑史维特莱德
if not pcall(function() require("expansions/script/c10120001") end) then require("script/c10120001") end
local m=10120005
local cm=_G["c"..m]
function cm.initial_effect(c)
	dsrsv.DanceSpiritSpecialSummonRule(c,cm.sprcon,cm.sprop)
	dsrsv.DanceSpiritSummonSucessEffect(c,m,nil,cm.sstg,cm.ssop,cm.sscon)
	dsrsv.DanceSpiritNegateEffect(c,m,CATEGORY_TODECK,cm.ntg,cm.nop)
end
function cm.ntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_HAND)
end
function cm.nop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND,nil)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(tp,1)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end
function cm.sscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)==0
end
function cm.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSummon(tp) end
end
function cm.ssop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,2,nil)
end
function cm.cfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsRace(RACE_FAIRY)
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
