--笑靥
function c65071075.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,65071075+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetTarget(c65071075.target)
	e1:SetOperation(c65071075.activate)
	c:RegisterEffect(e1)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCondition(c65071075.thcon)
	e4:SetTarget(c65071075.thtg)
	e4:SetOperation(c65071075.thop)
	c:RegisterEffect(e4)
	if c65071075.counter==nil then
		c65071075.counter=true
		c65071075[0]=0
		c65071075[1]=0
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e2:SetOperation(c65071075.resetcount)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_TO_GRAVE)
		e3:SetOperation(c65071075.addcount)
		Duel.RegisterEffect(e3,0)
	end
end

function c65071075.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c65071075[0]=0
	c65071075[1]=0
end
function c65071075.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsType(TYPE_MONSTER) then
			local p=tc:GetControler()
			c65071075[p]=c65071075[p]+1
		end
		tc=eg:GetNext()
	end
end

function c65071075.thcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return c65071075[1-tp]>=5
end
function c65071075.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c65071075.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return false end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end

function c65071075.chfil(c)
	return c:IsType(TYPE_MONSTER)
end

function c65071075.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(c65071075.chfil,tp,0,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,sg,sg:GetCount(),0,0)
	if sg:GetCount()>=10 then
	   Duel.SetChainLimit(c65071075.chlimit)
	end
end
function c65071075.chlimit(e,ep,tp)
	return tp==ep 
end

function c65071075.deval(e,te,tp)
	return te:GetOwner()~=e:GetOwner()
end

function c65071075.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local sg=Duel.GetMatchingGroup(c65071075.chfil,tp,0,LOCATION_GRAVE,nil)
	local tc=g:GetFirst()
	local con=sg:GetCount()
	if con>=1 then
		local atk=con*200
		--atk up
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(atk)
		tc:RegisterEffect(e1)
	end
	if con>=5 then
		--Unbrak
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetValue(1)
		tc:RegisterEffect(e2)
	end
	if con>=10 then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_ATTACK_ALL)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e3:SetValue(1)
		tc:RegisterEffect(e3)
	end
	if con>=15 then
		--Untarget
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e4:SetRange(LOCATION_MZONE)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e4:SetValue(c65071075.deval)
		tc:RegisterEffect(e4)
	end
	if con>=20 then
		--actlimit
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e5:SetCode(EFFECT_CANNOT_ACTIVATE)
		e5:SetRange(LOCATION_MZONE)
		e5:SetTargetRange(0,1)
		e5:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e5:SetValue(c65071075.aclimit)
		e5:SetCondition(c65071075.actcon)
		tc:RegisterEffect(e5)
	end
	if con>=25 then
		--immune
		local e1=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_IMMUNE_EFFECT)
		e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e6:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e6:SetRange(LOCATION_MZONE)
		e6:SetValue(c65071075.deval)
		c:RegisterEffect(e6)
	end
end

function c65071075.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c65071075.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
