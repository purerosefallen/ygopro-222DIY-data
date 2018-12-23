--崩坏新生 命运绮路
function c75646207.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,75646207+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c75646207.cost)
	e1:SetTarget(c75646207.target)
	e1:SetOperation(c75646207.activate)
	c:RegisterEffect(e1)
end
function c75646207.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c75646207.cfilter(c,tc,tp)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToGraveAsCost()
	and Duel.IsExistingMatchingCard(c75646207.eqfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode(),tc)
end
function c75646207.efilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x2c0)
		and Duel.IsExistingMatchingCard(c75646207.cfilter,tp,LOCATION_SZONE,0,1,nil,c,tp)
end
function c75646207.eqfilter(c,code,tc)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0x2c0) and c:CheckEquipTarget(tc) and not c:IsCode(code)
end
function c75646207.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c75646207.efilter(chkc,tp) end
	if chk==0 then 
	if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c75646207.efilter,tp,LOCATION_MZONE,0,1,nil,tp) end		   
	local g1=Duel.GetMatchingGroup(c75646207.efilter,tp,LOCATION_MZONE,0,1,nil,tp) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP) 
	Duel.SelectTarget(tp,c75646207.efilter,tp,LOCATION_MZONE,0,1,1,nil,tp)	
	local g2=Duel.SelectMatchingCard(tp,c75646207.cfilter,tp,LOCATION_SZONE,0,1,1,nil,g1:GetFirst(),tp)  
	Duel.SendtoGrave(g2,REASON_COST)
	e:SetLabelObject(g2:GetFirst())
end
function c75646207.activate(e,tp,eg,ep,ev,re,r,rp)
	local dc=e:GetLabelObject()
	local ec=Duel.GetFirstTarget()
	if ec:IsFacedown() or not ec:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c75646207.eqfilter,tp,LOCATION_DECK,0,1,1,nil,dc:GetCode(),ec)
	local eq=g:GetFirst()
	if eq then
		Duel.Equip(tp,eq,ec,true)
		eq:AddCounter(0x1b,2)
	end
end