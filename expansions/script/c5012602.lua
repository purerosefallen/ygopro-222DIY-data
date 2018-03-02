--御坂美琴
function c5012602.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c5012602.spcon)
	e1:SetOperation(c5012602.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(5012602,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_COIN+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c5012602.descost)
	e2:SetTarget(c5012602.destg)
	e2:SetOperation(c5012602.desop)
	c:RegisterEffect(e2)
	--buff
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,5012602)
	e5:SetCost(c5012602.cost)
	e5:SetTarget(c5012602.tg)
	e5:SetOperation(c5012602.op)
	c:RegisterEffect(e5)
end
function c5012602.spcon(e,c)
	if c==nil then return true end
	return  Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c5012602.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(-500)
	e1:SetReset(RESET_EVENT+0xff0000)
	e:GetHandler():RegisterEffect(e1)
end
function c5012602.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local res=Duel.TossCoin(tp,1)
	e:SetLabel(res)
end
function c5012602.filter(c,seq)
	return c:GetSequence()==seq and c:IsDestructable()
end
function c5012602.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=e:GetHandler():GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and e:GetHandler():GetAttack()>=800 and cg:GetCount()>0 end
	local res=e:GetLabel()
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	if res~=0 then
	   Duel.SetOperationInfo(0,CATEGORY_DESTROY,cg,cg:GetCount(),0,0)
	end
end
function c5012602.desop(e,tp,eg,ep,ev,re,r,rp)
	local cg=e:GetHandler():GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	local res=e:GetLabel()
	if res~=0 then
		if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)>0 and cg:GetCount()>0 then
		Duel.Destroy(cg,REASON_EFFECT)
		end
	else
	if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)>0 then
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(-800)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	e:GetHandler():RegisterEffect(e2)
	end
	end
end
function c5012602.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c5012602.refilter(c)
	return c:IsFaceup() and  (c:IsSetCard(0x250) or c:IsSetCard(0x23c)or c:IsSetCard(0x997) ) 
end
function c5012602.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5012602.refilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c5012602.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c5012602.refilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tg=g:GetFirst()
	while tg do
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tg:RegisterEffect(e1)
	tg=g:GetNext()
	end
end