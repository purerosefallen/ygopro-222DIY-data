--暗穹之龙骑士
function c65040009.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),true)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c65040009.descon)
	e1:SetTarget(c65040009.destg)
	e1:SetOperation(c65040009.desop)
	c:RegisterEffect(e1)
end
function c65040009.descon(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	return ac:IsControler(tp) and bc:IsPosition(POS_DEFENSE)
end
function c65040009.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=Duel.GetAttackTarget()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
end
function c65040009.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=Duel.GetAttackTarget()
	local ac=Duel.GetAttacker()
	local atk=ac:GetAttack()
	local def=bc:GetDefense()
	local dam=atk-def
	if dam<0 then dam=0-dam end
	if bc:IsRelateToBattle() then
		if Duel.Destroy(bc,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,dam,REASON_EFFECT)
		end
	end
end