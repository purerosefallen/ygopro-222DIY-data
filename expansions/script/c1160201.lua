--混沌形态·贞德
function c1160201.initial_effect(c)
--
	aux.AddXyzProcedure(c,aux.FALSE,1,2,c1160201.filter,aux.Stringid(1160201,0))	
	c:EnableReviveLimit()
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1160201,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,1160201+EFFECT_COUNT_CODE_DUEL)
	e1:SetTarget(c1160201.tg1)
	e1:SetOperation(c1160201.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c1160201.tg2)
	e2:SetValue(c1160201.val2)
	e2:SetOperation(c1160201.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c1160201.tfilter3)
	e3:SetValue(1)
	c:RegisterEffect(e3)
--
	if not c1160201.gchk then
		c1160201.gchk=true
		local e4=Effect.GlobalEffect()
		e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e4:SetCode(EVENT_DAMAGE)
		e4:SetOperation(c1160201.op4)
		Duel.RegisterEffect(e4,0)
	end
--
end
--
function c1160201.filter(c)
	return c:IsFaceup() and c:GetLevel()==1 and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_FIRE) and c:GetAttack()>399
end
--
function c1160201.tfilter1(c)
	return c:IsDestructable() and c:GetSequence()<5
end
function c1160201.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c1160201.tfilter1,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c1160201.tfilter1,tp,0,LOCATION_MZONE,1,2,nil)
	Duel.RegisterFlagEffect(tp,1160201,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
--
function c1160201.ofilter1_1(c,seq)
	return c:GetSequence()==seq
end
function c1160201.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		local tc1=g:GetFirst()
		local seq1=tc1:GetSequence()
		local seq2=seq1+16
		seq2=bit.lshift(0x1,seq2)
		local tc2=g:GetNext()
		local seq3=nil
		local seq4=nil
		if tc2 then
			seq3=tc3:GetSequence()
			seq4=seq3+16
			seq4=bit.lshift(0x1,seq4)
		end
		if Duel.Destroy(g,REASON_EFFECT)~=0 then
			local checknum1=0
			local checknum2=0
			if not Duel.IsExistingMatchingCard(c1160201.ofilter1_1,tp,0,LOCATION_MZONE,1,nil,seq1) then checknum1=1 end
			if seq3~=nil then 
				if not Duel.IsExistingMatchingCard(c1160201.ofilter1_1,tp,0,LOCATION_MZONE,1,nil,seq2) then checknum2=1 end
			end
			if checknum1==1 and checknum2==1 then
				seq2=bit.bor(seq2,seq4)
			elseif checknum2==1 then 
				seq2=seq4
			end
			local e1_1=Effect.CreateEffect(c)
			e1_1:SetType(EFFECT_TYPE_FIELD)
			e1_1:SetCode(EFFECT_DISABLE_FIELD)
			e1_1:SetOperation(function (e,tp) return seq2 end)
			if Duel.GetTurnPlayer()==1-tp then
				e1_1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
			else
				e1_1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
			end
			Duel.RegisterEffect(e1_1,tp)
		end
	end
end
--
function c1160201.tfilter2(c,tp)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and c:GetLevel()==1
end
function c1160201.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetDefense()>99 and eg:IsExists(c1160201.tfilter2,1,nil,tp) and Duel.GetFlagEffect(tp,1160201)<1 end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
--
function c1160201.val2(e,c)
	return c1160201.tfilter2(c,e:GetHandlerPlayer())
end
--
function c1160201.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_SINGLE)
	e2_1:SetCode(EFFECT_UPDATE_DEFENSE)
	e2_1:SetReset(RESET_EVENT+0x1fe0000)
	e2_1:SetValue(-100)
	c:RegisterEffect(e2_1)
end
--
function c1160201.tfilter3(e,c)
	return c:GetLevel()==1 and Duel.GetFlagEffect(e:GetHandler():GetControler(),1160201)<1 and Duel.GetFlagEffect(e:GetHandler():GetControler(),1160202)>0
end
--
function c1160201.op4(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(ep,1160202,RESET_PHASE+PHASE_END,0,1)
end
--
