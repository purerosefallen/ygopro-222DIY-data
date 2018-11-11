--红暗之翼
function c65040010.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),2,true)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c65040010.target)
	e1:SetOperation(c65040010.activate)
	c:RegisterEffect(e1)
end
function c65040010.tgfilter(c)
	return c:IsPosition(POS_DEFENSE) 
end
function c65040010.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c65040010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65040010.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and e:GetHandler():IsCanTurnSet() end
	local dam=Duel.GetMatchingGroupCount(c65040010.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)*500
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	if dam>0 then Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam) end
end
function c65040010.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.ChangePosition(g,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,true)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local dam=Duel.GetMatchingGroupCount(c65040010.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)*500
	if Duel.Damage(p,dam,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.ChangePosition(e:GetHandler(),POS_FACEDOWN_DEFENSE)
	end
end