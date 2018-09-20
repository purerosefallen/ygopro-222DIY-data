c77707028.dfc_back_side=77707028-1
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function c77707028.initial_effect(c)
	Senya.DFCBackSideCommonEffect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,77707028+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Destroy monsters, Allen gain 3k
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77707028,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,77707102+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c77707028.descon1)
	e2:SetTarget(c77707028.destg1)
	e2:SetOperation(c77707028.desop1)
	c:RegisterEffect(e2)
	--Negate Allen and Rilian and take no dmg
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(77707028,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,77707202+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e3:SetCondition(c77707028.negcon)
	e3:SetTarget(c77707028.negtg)
	e3:SetOperation(c77707028.negop)
	c:RegisterEffect(e3)
	--Remove all
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77707028,2))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,77707302+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e4:SetCondition(c77707028.rmcon)
	e4:SetCost(c77707028.rmcost)
	e4:SetTarget(c77707028.rmtg)
	e4:SetOperation(c77707028.rmop)
	c:RegisterEffect(e4)
	--Destroy all and SS a Drift Bottle Token
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(77707028,3))
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,77707402+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e5:SetCondition(c77707028.descon2)
	e5:SetTarget(c77707028.destg2)
	e5:SetOperation(c77707028.desop2)
	c:RegisterEffect(e5)
end
function c77707028.alfilter(c)
	return c:IsFaceup() and c:IsCode(77707004)
end
function c77707028.rifilter(c)
	return c:IsFaceup() and c:IsCode(77708001)
end
function c77707028.alrifilter(c)
	return c:IsFaceup() and (c:IsCode(77708001) or c:IsCode(77707004))
end
function c77707028.descon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c77707028.cfilter(c)
	return c:IsCode(77708002) and c:IsFaceup()
end
function c77707028.desfilter1(c)
	return c:IsType(TYPE_MONSTER) and not (c:IsCode(77707004) or c:IsCode(77708001))
end
function c77707028.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77707028.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(c77707028.desfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c77707028.desop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ct=Duel.GetMatchingGroupCount(c77707028.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(1-tp,c77707028.desfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	Duel.HintSelection(g)
	Duel.Destroy(g,REASON_EFFECT)
	local tg=Duel.GetMatchingGroup(c77707028.alfilter,tp,LOCATION_ONFIELD,0,nil)
	local tc=tg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(3000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=tg:GetNext()
	end
	Duel.RegisterFlagEffect(tp,77707028,RESET_EVENT+RESETS_STANDARD,0,1)
end
function c77707028.negcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:GetHandler():IsOnField() and re:GetHandler():IsRelateToEffect(re) and (re:IsActiveType(TYPE_MONSTER)
		or (re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE)))
		and Duel.GetFlagEffect(tp,77707028)~=0
end
function c77707028.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77707028.alfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(c77707028.rifilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,nil,1,0,0)
end
function c77707028.negop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tg=Duel.GetMatchingGroup(c77707028.alrifilter,tp,LOCATION_ONFIELD,0,nil)
	local tc=tg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		tc=tg:GetNext()
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local tg2=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_ONFIELD,nil)
	local tc2=tg2:GetFirst()
	while tc2 do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc2:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc2:RegisterEffect(e2)
		if tc2:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc2:RegisterEffect(e3)
		end
		tc2=tg2:GetNext()
	end
	Duel.RegisterFlagEffect(tp,77707102,RESET_EVENT+RESETS_STANDARD,0,1)
end
function c77707028.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,77707102)~=0
		and Duel.IsExistingMatchingCard(c77707028.rifilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c77707028.alfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c77707028.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)>1 end
	local lp=Duel.GetLP(tp)
	Duel.PayLPCost(tp,lp-1)
end
function c77707028.rmfilter(c)
	return c:IsAbleToRemove() and not c:IsCode(77708001)
end
function c77707028.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c77707028.rmfilter,tp,0x1e,0x1e,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c77707028.rmop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c77707028.rmfilter,tp,0x1e,0x1e,aux.ExceptThisCard(e))
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	Duel.RegisterFlagEffect(tp,77707202,RESET_EVENT+RESETS_STANDARD,0,1)
end
function c77707028.descon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,77707202)~=0 and Duel.GetLP(tp)>0
		and tp~=Duel.GetTurnPlayer()
end
function c77707028.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,77708003,0,0x4011,0,0,1,RACE_AQUA,ATTRIBUTE_WATER,POS_FACEUP) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c77707028.desop2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,0,nil)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)>0 then
		local token=Duel.CreateToken(tp,77708003)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		Duel.BreakEffect()
		Duel.SetLP(tp,0)
	end
end
