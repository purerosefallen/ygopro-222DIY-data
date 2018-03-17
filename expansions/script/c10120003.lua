--天选圣女 圣马罗丝薇瑟
if not pcall(function() require("expansions/script/c10120001") end) then require("script/c10120001") end
local m=10120003
local cm=_G["c"..m]
function cm.initial_effect(c)
	dsrsv.DanceSpiritSpecialSummonRule(c,cm.sprcon,nil)
	dsrsv.DanceSpiritSummonSucessEffect(c,m,nil,nil,cm.ssop)
	dsrsv.DanceSpiritNegateEffect(c,m,CATEGORY_SPECIAL_SUMMON,cm.ntg,cm.nop) 
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x9331) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.ntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.nop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	   Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.ssop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9331))
	e1:SetValue(500)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	Duel.RegisterEffect(e2,tp)
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFlagEffect(tp,10120001)>0
end
