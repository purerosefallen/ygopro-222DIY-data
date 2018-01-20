--花束与火·小红帽
function c1160021.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1160021,0))
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,1160021)
	e1:SetCondition(c1160021.con1)
	e1:SetOperation(c1160021.op1)
	c:RegisterEffect(e1)
--
	if not c1160021.gchk then
		c1160021.gchk=true
		c1160021[0]=5
		c1160021[1]=5
		local e2=Effect.GlobalEffect()
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		e2:SetOperation(c1160021.op2)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.GlobalEffect()
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e3:SetCountLimit(1)
		e3:SetOperation(c1160021.clear3)
		Duel.RegisterEffect(e3,0)
	end
--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1160021,0))
	e4:SetType(EVENT_FREE_CHAIN+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_HAND)
	e4:SetCountLimit(1,1160021)
	e4:SetTarget(c1160021.tg4)
	e4:SetOperation(c1160021.op4)
	c:RegisterEffect(e4)
--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(1160021,1))
	e5:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,1160022)
	e5:SetCost(c1160021.cost5)
	e5:SetTarget(c1160021.tg5)
	e5:SetOperation(c1160021.op5)
	c:RegisterEffect(e5)
--
end
--
function c1160021.con1(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():GetLevel()==1
end
--
function c1160021.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1_1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1_1:SetCondition(c1160021.con1_1)
	e1_1:SetOperation(c1160021.op1_1)
	e1_1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
	Duel.RegisterEffect(e1_1,tp)
end
--
function c1160021.con1_1(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c1160021.op1_1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.TossCoin(tp,1)==1 then
		Duel.NegateAttack()
	end
end
--
function c1160021.op2(e,tp,eg,ep,ev,re,r,rp)
	if c1160021[rp]<=1 then
		Duel.RegisterFlagEffect(rp,1160021,RESET_PHASE+PHASE_END,0,2)
	else
		c1160021[rp]=c1160021[rp]-1
	end
end
function c1160021.clear3(e,tp,eg,ep,ev,re,r,rp)
	c1160021[0]=5
	c1160021[1]=5
end
--
function c1160021.tfilter4(c,e,tp)
	return c:GetLevel()==1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1160021.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c1160021.tfilter4,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetFlagEffect(1-tp,1160021)>0 and e:GetHandler():IsLocation(LOCATION_HAND) end
end
--
function c1160021.op4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1160021.tfilter4,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
--
		local e1_1=Effect.CreateEffect(e:GetHandler())
		e1_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1_1:SetCode(EVENT_ATTACK_ANNOUNCE)
		e1_1:SetCondition(c1160021.con1_1)
		e1_1:SetOperation(c1160021.op1_1)
		e1_1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
		Duel.RegisterEffect(e1_1,tp)
--
	end
end
--
function c1160021.cfilter5(c)
	return c:IsAbleToRemoveAsCost()
end
function c1160021.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1160021.cfilter5,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(1-tp,c1160021.cfilter5,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
	local e5_1=Effect.CreateEffect(e:GetHandler())
	e5_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5_1:SetCode(EVENT_PHASE+PHASE_END)
	e5_1:SetRange(LOCATION_REMOVED)
	e5_1:SetCountLimit(1)
	e5_1:SetOperation(c1160021.op5_1)
	e5_1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e5_1)
end
function c1160021.op5_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end
--
function c1160021.tfilter5(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c1160021.tg5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c1160021.tfilter5,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectTarget(tp,c1160021.tfilter5,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,e:GetHandler(),1,0,0)
end
--
function c1160021.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local fcatk=c:GetAttack()
		local ftatk=tc:GetAttack()
		local e5_2=Effect.CreateEffect(e:GetHandler())
		e5_2:SetType(EFFECT_TYPE_SINGLE)
		e5_2:SetCode(EFFECT_SET_ATTACK_FINAL)
		e5_2:SetValue(fcatk)
		e5_2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e5_2)
		local e5_3=Effect.CreateEffect(e:GetHandler())
		e5_3:SetType(EFFECT_TYPE_SINGLE)
		e5_3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e5_3:SetValue(ftatk)
		e5_3:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e5_3)
		local ecatk=c:GetAttack()
		local etatk=tc:GetAttack()
		local atk1=math.abs(fcatk-ecatk)
		local atk2=math.abs(ftatk-etatk)
		local num=atk1+atk2
		if num>2650 then
			local gn=Group.CreateGroup()
			if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_SZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(1160021,2)) then
				local mg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_SZONE,nil)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local tc=mg:Select(tp,1,1,nil):GetFirst()
				mg:RemoveCard(tc)
				gn:AddCard(tc)
				num=num-2650
				while num>2650 do
					if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_SZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(1160021,2)) then
						tc=mg:Select(tp,1,1,nil):GetFirst()
						mg:RemoveCard(tc)
						gn:AddCard(tc)
					else
						break
					end
					num=num-2650
				end
			end
			if gn:GetCount()>0 then
				Duel.Destroy(gn,REASON_EFFECT)
			end
		end
	end
end
--

