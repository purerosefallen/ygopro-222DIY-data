--星之骑士拟身 羽毛
function c65090012.initial_effect(c)
	--fusion material
	c:SetSPSummonOnce(65090012)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,65090001,aux.FilterBoolFunction(Card.IsRace,RACE_WINDBEAST),1,true,true)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCountLimit(1)
	e2:SetCondition(c65090012.condition)
	e2:SetTarget(c65090012.target2)
	e2:SetOperation(c65090012.activate)
	c:RegisterEffect(e2)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCountLimit(1)
	e4:SetCondition(c65090012.descon)
	e4:SetTarget(c65090012.destg)
	e4:SetOperation(c65090012.desop)
	c:RegisterEffect(e4)
end
function c65090012.descon(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	return ac and not ac:IsControler(tp)
end
function c65090012.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,Duel.GetAttacker(),1,0,0)
end
function c65090012.desop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	if ac:IsRelateToBattle() then
		Duel.Destroy(ac,REASON_EFFECT)
	end
end
function c65090012.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c65090012.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetAttacker()
	if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) end
end
function c65090012.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc and tc:IsFaceup() and tc:IsRelateToBattle() then
		Duel.NegateAttack()
	end
end