--刑死的堕天司 沙利叶
function c47577910.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c47577910.psplimit)
	c:RegisterEffect(e1)  
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,47577910)
	e2:SetTarget(c47577910.drtg)
	e2:SetOperation(c47577910.drop)
	c:RegisterEffect(e2) 
	--summon with 1 tribute
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(47577910,0))
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SUMMON_PROC)
	e3:SetCondition(c47577910.otcon)
	e3:SetOperation(c47577910.otop)
	e3:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e4) 
	--  
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetOperation(c47577910.thop)
	c:RegisterEffect(e5)
	--copy effect
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(47577910,1))
	e7:SetCategory(CATEGORY_TODECK)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCountLimit(1,47577911)
	e7:SetTarget(c47577910.cptg)
	e7:SetOperation(c47577910.cpop)
	c:RegisterEffect(e7)
end
function c47577910.psplimit(e,c,tp,sumtp,sumpos)
	return not c:IsRace(RACE_FAIRY) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c47577910.drfilter(c)
	return c:IsLocation(LOCATION_HAND) and c:IsAbleToGraveAsCost() and c:IsRace(RACE_FAIRY)
end
function c47577910.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c47577910.drop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local g=Duel.GetMatchingGroup(c47577910.drfilter,tp,LOCATION_HAND,0,nil)
	local ct=math.min(ft-1,g:GetCount())
	local sg=g:Select(tp,1,ct,nil)
	local d=sg:GetCount()+1
	if Duel.SendtoGrave(sg,REASON_EFFECT)~=0 then
		Duel.Draw(tp,d,REASON_EFFECT)
	end
end
function c47577910.otfilter(c)
	return c:IsType(TYPE_PENDULUM)
end
function c47577910.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return c:GetLevel()>4 and minc<=1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c47577910.otfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,tp)
end
function c47577910.otop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=Duel.SelectMatchingCard(tp,c47577910.otfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c,tp)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c47577910.thfilter(c,e,tp,zone)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x95de)
end
function c47577910.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g=Duel.SelectMatchingCard(tp,c47577910.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
function c47577910.cpfilter(c)
	return c:IsSetCard(0x95de) and c:IsType(TYPE_SPELL) and c:IsAbleToDeck() and c:CheckActivateEffect(false,true,false)~=nil
end
function c47577910.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingTarget(c47577910.cpfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c47577910.cpfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.ClearTargetCard()
	g:GetFirst():CreateEffectRelation(e)
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,0,0)
end
function c47577910.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	if not te:GetHandler():IsRelateToEffect(e) then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	Duel.BreakEffect()
	Duel.SendtoDeck(te:GetHandler(),nil,2,REASON_EFFECT)
end