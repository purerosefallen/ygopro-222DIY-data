--传说的仁慈
function c33350004.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCondition(c33350004.condition)
	e1:SetTarget(c33350004.target)
	e1:SetOperation(c33350004.activate)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3) 
	--spsummon
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(33350004,0))
	e11:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e11:SetType(EFFECT_TYPE_ACTIVATE)
	e11:SetProperty(EFFECT_FLAG_DELAY)
	e11:SetCode(EVENT_DESTROYED)
	e11:SetCondition(c33350004.condition2)
	e11:SetTarget(c33350004.target2)
	e11:SetOperation(c33350004.activate2)
	c:RegisterEffect(e11)   
	local e21=e11:Clone()
	e21:SetCode(EVENT_CHAINING)
	e21:SetCondition(c33350004.condition3)
	c:RegisterEffect(e21)   
end
function c33350004.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if chk==0 then return (not Duel.IsPlayerAffectedByEffect(tp,59822133) or ft==1)
		and ft>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33350003,0,0x4011,800,1000,1,RACE_PLANT,ATTRIBUTE_DARK,POS_FACEUP,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,4,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,4,0,0)
end
function c33350004.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if ft<=0 or (Duel.IsPlayerAffectedByEffect(tp,59822133) and ft>1) then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,33350003,0,0x4011,800,1000,1,RACE_PLANT,ATTRIBUTE_DARK,POS_FACEUP,1-tp) then return end
	for i=1,ft do
		local token=Duel.CreateToken(tp,33350003)
		Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		--token:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		--token:RegisterEffect(e2)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		--token:RegisterEffect(e4)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		token:RegisterEffect(e5)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		--token:RegisterEffect(e6)
	 end
	 Duel.SpecialSummonComplete()
end
function c33350004.condition3(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c33350004.cfilter3,1,nil,tp)
end
function c33350004.cfilter3(c,tp)
	return c:IsType(TYPE_MONSTER) and c.setname=="TaleSouls" and c:IsControler(tp) and c:IsFaceup()
end
function c33350004.cfilter2(c,tp)
	return c:IsType(TYPE_MONSTER) and c.setname=="TaleSouls" and c:GetPreviousControler()==tp and c:IsPreviousPosition(POS_FACEUP)
		and c:IsPreviousLocation(LOCATION_MZONE)
end
function c33350004.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33350004.cfilter2,1,nil,tp) 
end
function c33350004.filter(c)
	return c:IsAttackAbove(2000) and c:IsAbleToRemove()
end
function c33350004.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and eg:IsExists(c33350004.filter,1,nil) and Duel.IsExistingMatchingCard(c33350004.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c33350004.cfilter(c)
	return c:IsFaceup() and c.setname=="TaleSouls"
end
function c33350004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c33350004.filter,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c33350004.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c33350004.filter,nil)
	Duel.NegateSummon(g)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
