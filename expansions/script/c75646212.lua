--圣女降临
function c75646212.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c75646212.condition)
	e1:SetOperation(c75646212.activate)
	c:RegisterEffect(e1)
end
function c75646212.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_LINK)
end
function c75646212.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c75646212.splimit)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_ACTIVATING)
	e2:SetOperation(c75646212.disop)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c75646212.movcon)
	e3:SetOperation(c75646212.movop)
	Duel.RegisterEffect(e3,tp)	
end
function c75646212.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsType(TYPE_LINK)
end
function c75646212.disop(e,tp,eg,ep,ev,re,r,rp)
	local cp,ty=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_PLAYER,CHAININFO_EXTTYPE)
	if cp==e:GetHandlerPlayer() and ty==TYPE_LINK then
		Duel.NegateEffect(ev)
	end
end
function c75646212.cfilter(c,tp)
	return c:IsSetCard(0x2c0) and c:GetSummonPlayer()==tp and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c75646212.movcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75646212.cfilter,1,nil,tp)
end
function c75646212.movop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=eg:Filter(c75646212.cfilter,nil,tp)
	local tc=g:GetFirst()
	if tc then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
			local nseq=math.log(s,2)
			Duel.MoveSequence(tc,nseq)
		end
end