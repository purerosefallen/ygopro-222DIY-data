--酒红之阿莉西娅
function c65011016.initial_effect(c)
	c:EnableReviveLimit()
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c65011016.sprcon)
	e0:SetOperation(c65011016.sprop)
	c:RegisterEffect(e0)
	--spsum
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,65011016)
	e1:SetCost(c65011016.spdcost)
	e1:SetTarget(c65011016.spdtg)
	e1:SetOperation(c65011016.spdop)
	c:RegisterEffect(e1)
end
function c65011016.sprfilter(c)
	return c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function c65011016.sprfilter1(c,tp,g,sc)
	local lv=c:GetLevel()
	return c:IsType(TYPE_TUNER) and g:IsExists(c65011016.sprfilter2,1,c,tp,c,sc,lv)
end
function c65011016.sprfilter2(c,tp,mc,sc,lv)
	local sg=Group.FromCards(c,mc)
	return c:GetLevel()==lv-1 and c:GetOriginalLevel()>0 
		and Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0
end
function c65011016.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c65011016.sprfilter,tp,LOCATION_MZONE,0,nil)
	return g:IsExists(c65011016.sprfilter1,1,nil,tp,g,c)
end
function c65011016.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c65011016.sprfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:FilterSelect(tp,c65011016.sprfilter1,1,1,nil,tp,g,c)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=g:FilterSelect(tp,c65011016.sprfilter2,1,1,mc,tp,mc,c,mc:GetLevel())
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end

function c65011016.cosfil(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsLevelAbove(2)
end

function c65011016.spdcost(e,t,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end

function c65011016.spdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c65011016.cosfil,tp,LOCATION_EXTRA,0,1,nil)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,65011017,0,0x4011,0,0,1,RACE_FAIRY,ATTRIBUTE_DARK,POS_FACEUP,tp) 
	end
	local rg=Duel.SelectMatchingCard(tp,c65011016.cosfil,tp,LOCATION_EXTRA,0,1,1,nil)
	local tc=rg:GetFirst()
	local lv=tc:GetLevel()
	Duel.ConfirmCards(1-tp,tc)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	e:SetLabel(lv)
end
function c65011016.spdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lve=e:GetLabel()
	local lv=lve-1
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,65011017,0,0x4011,0,0,1,RACE_FAIRY,ATTRIBUTE_DARK,POS_FACEUP,tp) then return end
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		Duel.BreakEffect()
		local token=Duel.CreateToken(tp,65011017)
		if Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) then
		--cannot link
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		e3:SetValue(1)
		token:RegisterEffect(e3)
		end
		Duel.SpecialSummonComplete()
	end
end