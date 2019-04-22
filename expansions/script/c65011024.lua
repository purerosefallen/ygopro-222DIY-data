--命运预示者
function c65011024.initial_effect(c)
	 c:EnableReviveLimit()
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c65011024.sprcon)
	e0:SetOperation(c65011024.sprop)
	c:RegisterEffect(e0)
	--changelevel
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c65011024.lvcost)
	e1:SetTarget(c65011024.lvtg)
	e1:SetOperation(c65011024.lvop)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(c65011024.efilter)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(c65011024.indval)
	c:RegisterEffect(e3)
end
function c65011024.indval(e,c)
	return c:GetBattleTarget():GetLevel()>c:GetLevel() and c:GetLevel()>0
end
function c65011024.efilter(e,te,c)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwner():GetLevel()<c:GetLevel() and te:GetOwner():GetLevel()>0
		and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end

function c65011024.costfil(c)
	return c:GetOriginalLevel()>0 and c:IsAbleToRemoveAsCost()
end
function c65011024.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65011024.costfil,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c65011024.costfil,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	e:SetLabel(g:GetFirst():GetLevel())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c65011024.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local lv=e:GetLabel()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,lv*200)
end
function c65011024.lvfil(c)
	return c:IsFaceup() and c:GetLevel()>0
end
function c65011024.lvop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	local g=Duel.GetMatchingGroup(c65011024.lvfil,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(lv)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	Duel.Damage(1-tp,lv*200,REASON_EFFECT)
end

function c65011024.sprfilter(c)
	return c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c65011024.sprfilter1(c,tp,g,sc)
	local lv=c:GetLevel()
	return c:IsType(TYPE_TUNER) and g:IsExists(c65011024.sprfilter2,1,c,tp,c,sc,lv)
end
function c65011024.sprfilter2(c,tp,mc,sc,lv)
	local sg=Group.FromCards(c,mc)
	return c:GetLevel()==lv-5 and c:GetOriginalLevel()>0 and not c:IsType(TYPE_TUNER)
		and Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0
end
function c65011024.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c65011024.sprfilter,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(c65011024.sprfilter1,1,nil,tp,g,c)
end
function c65011024.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c65011024.sprfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:FilterSelect(tp,c65011024.sprfilter1,1,1,nil,tp,g,c)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=g:FilterSelect(tp,c65011024.sprfilter2,1,1,mc,tp,mc,c,mc:GetLevel())
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end