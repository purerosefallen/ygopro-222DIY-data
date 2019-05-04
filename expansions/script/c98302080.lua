--EXEC_RIG=VEDA/.
function c98302080.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c98302080.actcon)
	e1:SetTarget(c98302080.target)
	e1:SetOperation(c98302080.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_ACTIVATE)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCondition(c98302080.actcon2)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_HAND)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e3:SetCost(c98302080.cost)
	e3:SetCondition(c98302080.actcon3)
	c:RegisterEffect(e3)
	if not c98302080.global_check then
		c98302080.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(c98302080.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c98302080.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsType(TYPE_MONSTER) or tc:IsType(TYPE_TOKEN) or tc:IsType(TYPE_TRAPMONSTER) then
			Duel.RegisterFlagEffect(0,98302080,RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
function c98302080.mzfilter(c,tp)
	return c:IsSetCard(0xad2) and c:IsFaceup() and c:IsControler(tp)
end
function c98302080.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98302080.mzfilter,tp,LOCATION_MZONE,0,1,nil,tp) and (e:GetHandler():IsLocation(LOCATION_SZONE) or not Duel.IsPlayerAffectedByEffect(tp,98300000))
end
function c98302080.actcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98302080.mzfilter,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.IsPlayerAffectedByEffect(tp,98300000)
end
function c98302080.actcon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c98302080.mzfilter,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.IsPlayerAffectedByEffect(tp,98300000) and Duel.GetTurnPlayer()~=tp
end
function c98302080.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end

function c98302080.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	local dm=Duel.GetMatchingGroupCount(nil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local dmf=math.floor(dm)
	local ph=Duel.GetCurrentPhase()
	if chk==0 then return (Duel.GetBattledCount(tp)~=0 or Duel.GetBattledCount(1-tp)~=0) and Duel.IsPlayerCanDraw(tp,dmf) and Duel.GetFlagEffect(0,98302080)==0 and ph==PHASE_MAIN2 end
	local dm=Duel.GetMatchingGroupCount(nil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local dmf=math.floor(dm)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,nil,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,dmf,0,0)
end
function c98302080.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c98302080.mzfilter,tp,LOCATION_MZONE,0,1,nil,tp) then return false end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(98302080,1))
	local dm=Duel.GetMatchingGroupCount(nil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local dmf=math.floor(dm)
	if dmf>0 and Duel.IsPlayerCanDraw(tp,dmf) then
	Duel.Recover(tp,2000,REASON_EFFECT,true)
	Duel.Recover(1-tp,2000,REASON_EFFECT,true)
	Duel.RDComplete()
	Duel.Draw(tp,dmf,REASON_EFFECT)
	end
end
