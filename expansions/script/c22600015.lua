--音语—热舞之电吉他
function c22600015.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22600015)
	e1:SetCondition(c22600015.spcon)
	c:RegisterEffect(e1)
	
	--banish deck
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(c22600015.dkcon)
	e3:SetTarget(c22600015.dktg)
	e3:SetOperation(c22600015.dkop)
	c:RegisterEffect(e3)
end

function c22600015.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x260) and not c:IsCode(22600015)
end

function c22600015.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c22600015.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end

function c22600015.dkcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp
end

function c22600015.dktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>2 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,3,1-tp,LOCATION_DECK)
end

function c22600015.dkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>2 then
		local tg=Duel.GetDecktopGroup(1-tp,3)
		Duel.DisableShuffleCheck()
		Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)
	end
end
