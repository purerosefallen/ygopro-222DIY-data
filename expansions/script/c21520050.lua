--满溢的灵子殖装
function c21520050.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--recover *200
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520050,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetTarget(c21520050.rtg1)
	e1:SetOperation(c21520050.rop1)
	c:RegisterEffect(e1)
	--recover *500
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520050,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c21520050.rcon2)
	e2:SetTarget(c21520050.rtg2)
	e2:SetOperation(c21520050.rop2)
	c:RegisterEffect(e2)
end
function c21520050.rfilter(c)
	return c:GetEquipGroup():FilterCount(Card.IsSetCard,nil,0x494)>0
end
function c21520050.rfilter2(c)
	return c:IsPreviousSetCard(0x494) and c:IsPreviousLocation(LOCATION_ONFIELD) and not c:IsCode(21520050)
end
function c21520050.rtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsFaceup() and Duel.IsExistingMatchingCard(c21520050.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c21520050.rop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	local g=Duel.GetMatchingGroup(c21520050.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	local ct=0
	while tc do
		if tc:IsType(TYPE_XYZ) then
			ct=ct+tc:GetRank()
		else
			ct=ct+tc:GetLevel()
		end
		tc=g:GetNext()
	end
	Duel.Recover(tp,ct*200,REASON_EFFECT)
end
function c21520050.rcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c21520050.rfilter2,1,nil)
end
function c21520050.rtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsFaceup() end
end
function c21520050.rop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	local ct=eg:FilterCount(c21520050.rfilter2,nil)
	Duel.Recover(tp,ct*500,REASON_EFFECT)
end
