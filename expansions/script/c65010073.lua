--终末旅者指挥 千户长
function c65010073.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),c65010073.matfil,1)
	c:EnableReviveLimit()
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(c65010073.splimit)
	c:RegisterEffect(e0)
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c65010073.chcon)
	e1:SetTarget(c65010073.chtg)
	e1:SetOperation(c65010073.chop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c65010073.indtg)
	e2:SetValue(aux.indoval)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--synchro level
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SYNCHRO_LEVEL)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c65010073.slevel)
	c:RegisterEffect(e4)
end
c65010073.setname="RagnaTravellers"
function c65010073.matfil(c)
	return c.setname=="RagnaTravellers" and not c:IsType(TYPE_TUNER) 
end
function c65010073.chcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local check=0
	if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then 
		local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS) 
		local tc=g:GetFirst()
		while tc do
			if not tc:IsLocation(LOCATION_ONFIELD) then check=1 end
			tc=g:GetNext()
		end
	end
	return rp==1-tp and ((re:GetActivateLocation()~=LOCATION_ONFIELD and not re:IsHasType(EFFECT_TYPE_ACTIVATE)) or check==1)
end
function c65010073.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c65010073.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c65010073.repop)
end
function c65010073.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetType()==TYPE_SPELL or c:GetType()==TYPE_TRAP then
		c:CancelToGrave(false)
	end
	Duel.Damage(tp,1000,REASON_EFFECT)
end
function c65010073.slevel(e,c)
	local lv=e:GetHandler():GetLevel()
	return 5*65536+lv
end
function c65010073.splimit(e,se,sp,st)
	return not se 
end
function c65010073.indtg(e,c)
	return c.setname=="RagnaTravellers"
end