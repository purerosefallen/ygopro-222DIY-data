--眠少女 潘多拉
function c65040015.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c65040015.descost)
	e1:SetCondition(c65040015.descon)
	e1:SetTarget(c65040015.destg)
	e1:SetOperation(c65040015.desop)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c65040015.condition)
	e2:SetTarget(c65040015.target)
	e2:SetOperation(c65040015.operation)
	c:RegisterEffect(e2)  
end
function c65040015.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsType,1,nil,TYPE_MONSTER)
end
function c65040015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) end
end
function c65040015.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(Card.IsType,nil,TYPE_MONSTER)
	if c:IsRelateToEffect(e) then
		Duel.Overlay(c,g)
	end
end
function c65040015.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local og=e:GetHandler():GetOverlayGroup()
	if chk==0 then return og:GetCount()>0 and og:FilterCount(Card.IsAbleToRemoveAsCost,nil)>0 end
	local g=og:FilterSelect(tp,Card.IsAbleToRemoveAsCost,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c65040015.descon(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	return (ac~=nil and ac:IsControler(tp)) and (bc~=nil and bc:IsControler(1-tp))
end
function c65040015.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=Duel.GetAttackTarget()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,bc,1,0,0)
end
function c65040015.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetAttackTarget()
	if bc:IsRelateToBattle() then
		Duel.SendtoGrave(bc,REASON_EFFECT)
	end
end