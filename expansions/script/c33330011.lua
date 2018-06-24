--深界生物 毯毯鼠
function c33330011.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x556),1,1)
	c:EnableReviveLimit()   
	--d r
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33330011,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,33330011)
	e2:SetTarget(c33330011.destg)
	e2:SetOperation(c33330011.desop)
	c:RegisterEffect(e2)
	--disable attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33330011,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCost(c33330011.atkcost)
	e1:SetCondition(c33330011.atkcon)
	e1:SetOperation(c33330011.atkop)
	c:RegisterEffect(e1)
end
function c33330011.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x1019,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x1019,1,REASON_COST)
end
function c33330011.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
function c33330011.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c33330011.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if chk==0 then return tc and e:GetHandler():IsCanAddCounter(0x1019,1) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,tp,LOCATION_FZONE)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0)
end
function c33330011.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if tc and Duel.Destroy(tc,REASON_EFFECT)~=0 and e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFaceup() then
	   e:GetHandler():AddCounter(0x1019,1)
	end
end
