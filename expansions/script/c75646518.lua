--西琳·铸魂
function c75646518.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,4,4)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c75646518.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75646518,0))	
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c75646518.remcon)
	e2:SetOperation(c75646518.remop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCondition(c75646518.con)
	e4:SetTarget(c75646518.tg)
	e4:SetOperation(c75646518.op)
	c:RegisterEffect(e4)
end
function c75646518.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetLinkedGroup()
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
function c75646518.cfilter(c,g)
	return c:IsFaceup() and g:IsContains(c)
end
function c75646518.remcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return lg and eg:IsExists(c75646518.cfilter,1,nil,lg)
end
function c75646518.remop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	if not lg then return end
	local g=eg:Filter(c75646518.cfilter,nil,lg)
	local tc=g:GetFirst()
	while tc do
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
		tc=g:GetNext()
	end
end
function c75646518.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_BATTLE) or (c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT)))
		and c:IsPreviousPosition(POS_FACEUP)
end
function c75646518.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemove()
end
function c75646518.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(c75646518.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,0)
end
function c75646518.op(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c75646518.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
end