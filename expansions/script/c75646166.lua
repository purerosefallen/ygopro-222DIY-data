--崩坏神格 刻音
function c75646166.initial_effect(c)
	c:EnableCounterPermit(0x1b)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c75646166.target)
	e1:SetOperation(c75646166.operation)
	c:RegisterEffect(e1)
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(400)
	e2:SetCondition(c75646166.con)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c75646166.con)
	e3:SetTarget(c75646166.tg)
	e3:SetOperation(c75646166.op)
	c:RegisterEffect(e3)   
	--equip limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(c75646166.eqlimit)
	c:RegisterEffect(e4)
end
c75646166.card_code_list={75646164}
function c75646166.eqlimit(e,c)
	return c:IsSetCard(0x2c0)
end
function c75646166.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x2c0)
end
function c75646166.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c75646166.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c75646166.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c75646166.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c75646166.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
		e:GetHandler():AddCounter(0x1b,2)
	end
end
function c75646166.con(e)
	return e:GetHandler():GetCounter(0x1b)>0
end
function c75646166.eqfilter(c,e)
	return c:IsCode(75646166) and c:CheckEquipTarget(e:GetHandler():GetEquipTarget())
end
function c75646166.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75646166.eqfilter,tp,LOCATION_DECK,0,1,nil,e) 
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c75646166.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler():GetEquipTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c75646166.eqfilter,tp,LOCATION_DECK,0,1,1,nil,e)
	if c:IsFacedown() then return end
	local etc=g:GetFirst()
	e:GetHandler():RemoveCounter(tp,0x1b,1,REASON_EFFECT)
	Duel.Equip(tp,etc,c,true)
	etc:AddCounter(0x1b,1)
end